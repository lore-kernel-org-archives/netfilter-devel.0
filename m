From: Peter Hoare <Peter.Hoare@signal.qinetiq.com>
Subject: changing packets with libipq
Date: Thu, 12 Dec 2002 12:12:12 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DF87D1C.B276B46@signal.qinetiq.com>
Reply-To: peteh@signal.qinetiq.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------CE24D1F796DA77CBCB12AF2E"
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
--------------CE24D1F796DA77CBCB12AF2E
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

We are having problems in trying to use the userspace libipq to change
incoming packets to the kernel. We are picking up UDP packets off the
pre-routing queue, changing the packet header and checksums and then
accepting the new packet back through the ipq_set_verdict() call with
NF_ACCEPT.

This new packet is being delivered quite happily to an end-user
application on the local machine  but if the packet is to be forwarded
through this host to another machine it appears to be dropped by the
kernel. Is there a limit to what we are allowed to change in the packet
through libipq? (There are some hints in the documentation to do with
caching fields in the skb that may be the cause of our problem). Our
guess is that because we are significantly changing the header that the
new packet is no longer being recognised as related to the old one? 

Is what we are doing not possible using libipq? If not do we have to
write a kernel module to do it or is there any other way to do it in
userspace?

Thank you

Peter Hoare
--------------CE24D1F796DA77CBCB12AF2E
Content-Type: text/x-vcard; charset=us-ascii;
 name="Peter.Hoare.vcf"
Content-Transfer-Encoding: 7bit
Content-Description: Card for Peter Hoare
Content-Disposition: attachment;
 filename="Peter.Hoare.vcf"

begin:vcard 
n:Hoare;Peter 
tel;fax:+44 1684 894389
tel;work:+44 1684 896438
x-mozilla-html:TRUE
url:www.qinetiq.com
org:QinetiQ;Sensors and Information Processing
version:2.1
email;internet:peteh@signal.qinetiq.com
title:Principal Scientist
adr;quoted-printable:version:2.1;;E204 =0D=0AQinetiQ=0D=0ASt Andrews Road;Malvern;Worcs;WR14 3PS;UK
note;quoted-printable:The Information contained in this e-mail and any subsequent =0D=0Acorrespondence is private and is intended solely for the =0D=0Aintended recipient(s). For those other than the intended recipient =0D=0Aany disclosure, copying, distribution, or any action taken or =0D=0Aomitted to be taken in reliance on such information is prohibited =0D=0Aand may be unlawful.=0D=0A=0D=0AThe views expressed above are entirely those of the  writer and =0D=0Ado not represent the views, policy or understanding of any other =0D=0Aperson or official body.
fn:Pete Hoare
end:vcard

--------------CE24D1F796DA77CBCB12AF2E--
