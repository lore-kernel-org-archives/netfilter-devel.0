From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: pom-20040409: patches that break iptables-1.2.9-20040409,
 kernel 2.4.25 or pom's runme
Date: Sun, 11 Apr 2004 16:16:11 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040411161611.3c7541b9.johnpol@2ka.mipt.ru>
References: <407928B7.6040505@fl.priv.at>
	<20040411155523.1fd06a78.johnpol@2ka.mipt.ru>
	<40793201.4070906@fl.priv.at>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Sun__11_Apr_2004_16_16_11_+0400_6+Ky=VzYS2/KImk/"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Friedrich Lobenstock <fl@fl.priv.at>
In-Reply-To: <40793201.4070906@fl.priv.at>
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

--Multipart=_Sun__11_Apr_2004_16_16_11_+0400_6+Ky=VzYS2/KImk/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 11 Apr 2004 13:54:41 +0200
Friedrich Lobenstock <fl@fl.priv.at> wrote:

> > What sources do you use?
> > You need CVS pom-ng + CVS iptables/extensions/libipt_osf.c for
> > successfull compilation.
> > 
> > IPT_OSF_NETLINK is defined in
> > patch-o-matic-ng/osf/linux/include/linux/netfilter_ipv4/ipt_osf.h:
> > 
> > #define IPT_OSF_NETLINK		8
> > 
> > 
> > With CVS pom-ng and CVS iptables/extensions/libipt_osf.c I can
> > compile both libipt_osf.so and ipt_osf.o ( using my own scripts, but
> > it doesn't matter).
> 
> I use plain pom, not pom-ng! Otherwise I would have written pom-ng in
> the subject.

Yep.
POM is deprecated is not supported any more.
I think it will dissapear in the near future.

Attached patch disables netlink notification but should not be applied
to CVS libipt_osf.c, it is only for those who use POM instead of POM-NG.

> 
> > Thank you for review.
> 
> You're welcome.
> 
> -- 
> MfG / Regards
> Friedrich Lobenstock


	Evgeniy Polyakov ( s0mbre )

Only failure makes us experts. -- Theo de Raadt

--Multipart=_Sun__11_Apr_2004_16_16_11_+0400_6+Ky=VzYS2/KImk/
Content-Type: application/octet-stream;
 name="diff"
Content-Disposition: attachment;
 filename="diff"
Content-Transfer-Encoding: base64

LS0tIC9ob21lL3MwbWJyZS9hV29yay9vc2YvbGliaXB0X29zZi5jCVNhdCBKYW4gMzEgMTk6NTc6
MzkgMjAwNAorKysgbGliaXB0X29zZi5jCVN1biBBcHIgMTEgMTY6MTI6NDIgMjAwNApAQCAtMTAz
LDEwICsxMDMsMTIgQEAKIAkJCWluZm8tPmZsYWdzIHw9IElQVF9PU0ZfTE9HOwogCQkJYnJlYWs7
CiAJCWNhc2UgJzQnOiAvKiAtLW5ldGxpbmsgKi8KKyNpZiAwCiAJCQlpZiAoKmZsYWdzICYgSVBU
X09TRl9ORVRMSU5LKQogCQkJCWV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sICJDYW4ndCBz
cGVjaWZ5IG11bHRpcGxlIHNtYXJ0IHBhcmFtZXRlciIpOwogCQkJKmZsYWdzIHw9IElQVF9PU0Zf
TkVUTElOSzsKIAkJCWluZm8tPmZsYWdzIHw9IElQVF9PU0ZfTkVUTElOSzsKKyNlbmRpZgogCQkJ
YnJlYWs7CiAJCWRlZmF1bHQ6CiAJCQlyZXR1cm4gMDsK

--Multipart=_Sun__11_Apr_2004_16_16_11_+0400_6+Ky=VzYS2/KImk/--
