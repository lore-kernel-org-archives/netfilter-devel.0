From: <murugan.venugopal@wipro.com>
Subject: Need help to hookup helper modules for 2.6 kernal
Date: Fri, 10 Nov 2006 21:50:43 +0530
Message-ID: <2A1A6E935323B04BB28608B01B9B077A03251335@CHN-SNR-MBX01.wipro.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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


Hi everyone,=0D
I need some help for hooking up functions in NAT for 2.6 kernal. can any
one help me where i need to pass arguments to call my function call.=0D
i studied the module ip_nat_ftp.c and studied how hookup is implemented
but i can't get any idea=0D
in the func they have attached the func call ip_nat_ftp to the hook
ip_nat_ftp_hook, but it was difficult for me to get to the file where
they have really declared=0D
all the parameters to call this hooking function. i went through the
documents but it is for 2.4 kernal which is entirely different from this
one.=0D
static int __init init(void)
{
BUG_ON(ip_nat_ftp_hook);
ip_nat_ftp_hook =3D ip_nat_ftp;
return 0;
}
can any one help me to guide me through this or any link where i can
learn.=0D
thanks in advance.=0D
regards,=0D
murugan



The information contained in this electronic message and any attachments to=
 this message are intended for the exclusive use of the addressee(s) and=
 may contain proprietary, confidential or privileged information. If you=
 are not the intended recipient, you should not disseminate, distribute or=
 copy this e-mail. Please notify the sender immediately and destroy all=
 copies of this message and any attachments.=0D

WARNING: Computer viruses can be transmitted via email. The recipient=
 should check this email and any attachments for the presence of viruses.=
 The company accepts no liability for any damage caused by any virus=
 transmitted by this email.
=0D
www.wipro.com
