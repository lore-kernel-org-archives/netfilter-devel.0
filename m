From: Grigory Bakunov <black@asplinux.ru>
Subject: about ip_tables.h code correction
Date: Wed, 16 Oct 2002 20:59:37 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200210161658.g9GGwWC21216@outpost.sw.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart_Wed__16_Oct_2002_20:59:37_+0400_0816b890"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Multipart_Wed__16_Oct_2002_20:59:37_+0400_0816b890
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Hello.

I work on my little project and need to use C++ compiler for that code.
But it's impossible now cause in ip_tables.h we can see

/* Helper functions */
static __inline__ struct ipt_entry_target *
ipt_get_target(struct ipt_entry *e)
{
        return (void *)e + e->target_offset;
}

For any c++ compiler it's a wrong code.
I know what all netfilter guru use plain C only but explict type correction it's
a good style of programming in any case :)

I make a little patch (in attchment).
It's correct this function to
/* Helper functions */
static __inline__ struct ipt_entry_target *
ipt_get_target(struct ipt_entry *e)
{
        return (struct ipt_entry_target *)((u_int8_t*)e + e->target_offset);
}

In other words - it's patch only one line.
Please tell me - i'm idiot or i'm right ? :)


........................................................................
IRC: irc.openprojects.net #asplinux                      Grigory Bakunov
EMAIL: black@asplinux.ru                           ASPLinux Support Team
ICQ: 51369901                                     http://www.asplinux.ru
-----BEGIN GEEK CODE BLOCK-----
GCS/MU d-(--) s:- a- C+++>++$ UBLAVSX+++$ P+ L++++$ E++$ W++ N+>- o? K?
w-- O- M V-(--) PS+ PE+ !Y PGP+>++++ t+ 5++ X+++ R+++ tv+>-- b+++ ?DI D+
G++ e>++$ h- r++ y+ z++(+++)
------END GEEK CODE BLOCK------

--Multipart_Wed__16_Oct_2002_20:59:37_+0400_0816b890
Content-Type: text/plain;
 name="ip_tables_h.syntax_correction.patch"
Content-Disposition: attachment;
 filename="ip_tables_h.syntax_correction.patch"
Content-Transfer-Encoding: base64

LS0tIGlwX3RhYmxlcy5oLm9sZAlNb24gQXVnIDI2IDE3OjA2OjAyIDIwMDIKKysrIGlwX3RhYmxl
cy5oCVdlZCBPY3QgMTYgMjA6NDc6MDcgMjAwMgpAQCAtMjkyLDcgKzI5Miw3IEBACiBzdGF0aWMg
X19pbmxpbmVfXyBzdHJ1Y3QgaXB0X2VudHJ5X3RhcmdldCAqCiBpcHRfZ2V0X3RhcmdldChzdHJ1
Y3QgaXB0X2VudHJ5ICplKQogewotCXJldHVybiAodm9pZCAqKWUgKyBlLT50YXJnZXRfb2Zmc2V0
OworCXJldHVybiAoc3RydWN0IGlwdF9lbnRyeV90YXJnZXQgKikoKHVfaW50OF90KillICsgZS0+
dGFyZ2V0X29mZnNldCk7CiB9CiAKIC8qIGZuIHJldHVybnMgMCB0byBjb250aW51ZSBpdGVyYXRp
b24gKi8K

--Multipart_Wed__16_Oct_2002_20:59:37_+0400_0816b890--
