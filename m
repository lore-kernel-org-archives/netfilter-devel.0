From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf-failover] Oops in ctnetlink_create_conntrack
Date: Sat, 13 Jan 2007 16:21:59 +0100
Message-ID: <45A8F917.9080002@trash.net>
References: <200701130319.30347.simonl@parknet.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090509020709050008070803"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter-failover@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Lodal <simonl@parknet.dk>
In-Reply-To: <200701130319.30347.simonl@parknet.dk>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090509020709050008070803
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Simon Lodal wrote:
> Hello
> 
> I got an oops in ctnetlink_create_conntrack when running 'conntrackd -c', with 
> a 'conntrackd -d' running. I hope this is the right place to report this bug.

Please CC netfilter-devel on bugreports.

> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000004
>  printing eip:
> *pde = 00000000
> Oops: 0000 [#1]
> SMP 
> Modules linked in: generic piix softdog e752x_edac eeprom i2c_dev i2c_i801 i2c_core parport_pc parport sd_mod ide_cd cdrom ide_disk usb_storage ide_core usbserial ehci_hcd uhci_hcd usbcore thermal processor fan ata_piix libata scsi_mod raid1 md_mod
> CPU:    1
> EIP:    0060:[<4029f2a7>]    Not tainted VLI
> EFLAGS: 00010202   (2.6.18.5-r2.8-p4smp #1) 
> EIP is at ctnetlink_create_conntrack+0x6e/0x3a7

I *think* this is already fixed in 2.6.19 by the attached patch.

Can you verify whether the patch fixes the problem? If it does
I'll push it to -stable.



--------------090509020709050008070803
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: ctnetlink: check for status attribute existence on conntrack creation

Check that status flags are available in the netlink message received
to create a new conntrack.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bbb3357d14f6becd156469220992ef7ab0f10e69
tree f24b5b6491c76d3b384bc09307d6b841fbc0370c
parent 1b683b551209ca46ae59b29572018001db5af078
author Pablo Neira Ayuso <pablo@netfilter.org> Wed, 29 Nov 2006 02:35:31 +0100
committer David S. Miller <davem@sunset.davemloft.net> Sat, 02 Dec 2006 21:31:27 -0800

 net/ipv4/netfilter/ip_conntrack_netlink.c |    8 +++++---
 net/netfilter/nf_conntrack_netlink.c      |    8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 3d277aa..d5d2efd 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -945,9 +945,11 @@ ctnetlink_create_conntrack(struct nfattr
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
 	ct->status |= IPS_CONFIRMED;
 
-	err = ctnetlink_change_status(ct, cda);
-	if (err < 0)
-		goto err;
+	if (cda[CTA_STATUS-1]) {
+		err = ctnetlink_change_status(ct, cda);
+		if (err < 0)
+			goto err;
+	}
 
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7357b8f..ba77183 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -963,9 +963,11 @@ ctnetlink_create_conntrack(struct nfattr
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
 	ct->status |= IPS_CONFIRMED;
 
-	err = ctnetlink_change_status(ct, cda);
-	if (err < 0)
-		goto err;
+	if (cda[CTA_STATUS-1]) {
+		err = ctnetlink_change_status(ct, cda);
+		if (err < 0)
+			goto err;
+	}
 
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);

--------------090509020709050008070803--
