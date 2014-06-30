From: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Subject: Parser stable fix question for CFG80211_INTERNAL_REGDB
Date: Mon, 30 Jun 2014 11:55:27 -0700
Message-ID: <CAB=NE6WfTXiScyXHReEWcpQ9EKpu1YCVQypa-B5BBO6aYXh3fA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: John Walker <john-40Xsf+s1Dzo@public.gmane.org>,
	Krishna Chaitanya <chaitanya.mgit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Richard Fontana <fontana-7LmRToLsLASJEOdND1YtKA@public.gmane.org>,
	"Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
To: linux-wireless <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>,
	"John W. Linville" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>,
	Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
	Felix Fietkau <nbd-p3rKhJxN3npAfugRpC6u6w@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

Folks,

John Walker reported an issue with 3.10 kernels not having the max
EIRP not set properly when CFG80211_INTERNAL_REGDB is used [0].
Krishna Chaitanya later confirmed this and annotated that an RFC I had
posted a while back, shortly after the change the created this issue,
is being carried over on OpenWrt as a fix for this [1]. The RFC was
for new kernels and it seems we just never got around to following up
and moving this upstream, so this change is certainly needed however
upon review on issues with older kernels I found an issue with
CFG80211_INTERNAL_REGDB which we hadn't considered before which we
should review in terms of strategy for newer kernels to avoid these
issues. Usage of CFG80211_INTERNAL_REGDB is popular for mobile and AP
devices. I'm Cc'ing the netfilter folks in case they might have some
ideas.

By design we have ensured that we make wireless-regdb backward
compatible with older versions of CRDA. We have done this well for a
while now by not requiring a binary format file change, but realizing
that at one point though we might have to upgrade the format and at
which point we may require two file formats on wireless-regdb for
different kernels. There's been some recent talks though over a new
strategy however which could always enable backward compatibility.
While those talks are underway we should consider that
CFG80211_INTERNAL_REGDB actually has a bit more different implications
on what we support on wireless-regdb for older kernels. The issue is
that CFG80211_INTERNAL_REGDB makes use of an awk script for parsing
the ASCII db.txt file, not the binary format. Commit e56cd9618e3e5
removed the antenna gain on wireless-regdb, upstream was not affected
for kernels using CRDA even when using older CRDA as the binary format
was not changed but since CFG80211_INTERNAL_REGDB relies on its own
ASCII parser older kernels are affected if this option is used. The
impact is that without an awk script  update the max EIRP will be 0
when CFG80211_INTERNAL_REGDB is used with new wireless-regdb so
devices can't transmit. What this also means is that when
CFG80211_INTERNAL_REGDB is used you cannot use older versions of
wireless-regdb unless we update the awk script, this however gets
tricky and the awk script can become complicated quickly. The change
below is an example change to make the the awk script backward
compatible upstream but for stable kernels we'd have port this a bit
-- we'd have to remove usage of the new dfs_cac as that wasn't
available on older kernels.

We need to decide what we want to do for older kernels, right now, and
in the future in consideration for the parser requirements on the
ASCII file by CFG80211_INTERNAL_REGDB then. For the current kernel we
could intake the patch below, and I can port the change to no use
dfs_cac, that would enable older kernels to use new and older versions
of the ASCII database file. For future kernels I started looking at
ditching the awk script completely and instead using the new C parser
already on CRDA. Another option is to have a something that reads the
regulatory binary file in the kernel, that is, a built-in CRDA. We can
use the C parser but that would require the making it also backward
compatible, today it is not, and #ifdef'ing some upstream code with
__KERNEL if we wanted to share some headers. I started mucking with
this as an option but it does require a bit of change. Having an
internal CRDA is a rather bigger change but one at this point worth
considering. I saw that for example recently we moved firmware
uploading into the kernel and that udev will soon remove the firmware
loader option. This a bit different change but a bit similar -- the
only difference here is that we do rely on RSA digital signatures on
the binary file, and we allow usage of either gcrypt or openssl for
verifying the signature on the file. When CFG80211_INTERNAL_REGDB is
used though we don't rely on any signatures though given that the file
is read and parsed at build time once so there is no chance to corrupt
the file. We could upkeep that behavior but the reading of the file
then would be binary to txt transformation, and it'd be a one time
thing at build time. If we wanted instead to have
CFG80211_INTERNAL_REGDB to mean that CRDA is then built-in to read
files from the filesystem at run time we'd have to decide if we wanted
to upkeep parsing the RSA digitial signature at read time.

I should note that CRDA is licensed under the copyleft-next license, I
have checked with Richard on license compatibility and he's verified
that copyleft-next is GPLv2 compatible and would not implicate any new
things if we're to share copyleft-next code on the kernel. It'd be no
different than for example how we have ISC licensed code upstream.
This would enable us to share code between userspace and kernel
however we wish.

We need a fix strategy, and also a path forward. What are folks thoughts?

[0] http://marc.info/?t=140093492500001&r=1&w=3
[1] https://dev.openwrt.org/browser/trunk/package/kernel/mac80211/patches/005-make-genregdb.awk-skip-antenna-gain.patch?rev=40296

  Luis

diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 40c37fc..8aa73b1 100644
--- a/net/wireless/genregdb.awI
+++ b/net/wireless/genregdb.awk
@@ -51,32 +51,48 @@ function parse_country_head() {

 function parse_reg_rule()
 {
+    flag_starts_at = 8
+
     start = $1
     sub(/\(/, "", start)
     end = $3
     bw = $5
     sub(/\),/, "", bw)
+
+    # We have two ASCII formats, one without the antenna gain
     gain = $6
-    sub(/\(/, "", gain)
-    sub(/,/, "", gain)
     power = $7
-    sub(/\)/, "", power)
+    units = $8
+    dfs_cac = 0
+
+    if (gain ~ /)/) {
+        flag_starts_at = 7
+
+        gain = 0
+        power = $6
+        units = $7
+        dfs_cac = $9
+        if (units != "mW")
+            dfs_cac = $8
+    } else  {
+        sub(/\(/, "", gain)
+        sub(/,/, "", gain)
+    }
+
+    sub(/\(/, "", power)
     sub(/,/, "", power)
+    sub(/\)/, "", power)
     # power might be in mW...
-    units = $8
     sub(/\)/, "", units)
     sub(/,/, "", units)
-    dfs_cac = $9
     if (units == "mW") {
         power = 10 * log(power)/log(10)
-    } else {
-        dfs_cac = $8
     }
     sub(/,/, "", dfs_cac)
     sub(/\(/, "", dfs_cac)
     sub(/\)/, "", dfs_cac)
     flagstr = ""
-    for (i=8; i<=NF; i++)
+    for (i=flag_starts_at; i<=NF; i++)
         flagstr = flagstr $i
     split(flagstr, flagarray, ",")
     flags = ""
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
