From: <peter_yen@trendmicro.com>
Subject: SO_ORIGINAL_DST and getsockopt
Date: Thu, 7 Jul 2005 18:05:40 -0700
Message-ID: <01642EB7E3370B439D58C010BFB4324804ABF0C9@UDCEXMAIL01.us.trendnet.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
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


Hi All,

=0D

I was running Kernel 2=2E6 with Netfilter and Netfilter-bridge kernel
modules loaded=2E

I saw some discussions regarding using getsockopt to retrieve the
original destination=0D

address after the packets have been redirected by iptables rules=2E
However, I cannot=0D

get the original destination address by calling getsockopt() from my
user-space server,=0D

the code would look like below=2E

=0D

if(getsockopt(connfd, SOL_IP, SO_ORIGINAL_DST, &oricliaddr, &oriclilen)
!=3D 0)

{

printf("error\n");

}

=0D

Did I miss out anything that prevents getsockopt() from getting the
original destination address?

Please enlighten me!!

=0D

Thanks a lot

=0D

Peter



TREND MICRO EMAIL NOTICE
The information contained in this email and any attachments is confidential=
 and may be subject to copyright or other intellectual property protection=
=2E If you are not the intended recipient, you are not authorized to use or=
 disclose this information, and we request that you notify us by reply mail=
 or telephone and delete the original message from your mail system=2E
