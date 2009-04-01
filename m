From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: Google SoC, Optimized netfilter implementation
Date: Wed, 1 Apr 2009 11:02:25 -0700
Message-ID: <20090401110225.0e50e969@nehalam>
References: <daf8006b0903311912g2c83d221w68197954d1e08d0d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Shreyas Bhatewara <shreyas.bhatewara@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:57967 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933065AbZDASCd convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Apr 2009 14:02:33 -0400
In-Reply-To: <daf8006b0903311912g2c83d221w68197954d1e08d0d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 31 Mar 2009 21:12:36 -0500
Shreyas Bhatewara <shreyas.bhatewara@gmail.com> wrote:

> Hello folks,
>=20
> I am a graduate student at Univ of Texas at Dallas. For the Google
> Summer of code, I am very much interested in improving netfilter
> implementation on Linux. I have worked with iptables (as user) and
> Linux kernel (as developer) earlier. Hence, although I do not know ho=
w
> exactly I can improve the netfilter performance as of now, I think I
> am in good position to understand and propose a solution to the
> problem during the project.
>=20
> I am composing a proposal for this project to be submitted at Google
> SoC. Could anyone brief me about what you mean by "dynamic code
> generation" (https://www.linuxfoundation.org/en/Google_Summer_of_Code=
_2009#Optimized_netfilter_implementation).
> It would be great if you could point me to some document/repository
> path which talks about this.
>=20
> Submitting a proposal requires me to introduce myself on this mailing
> list. For details about me, please refer to my resume :
> http://utdallas.edu/~shreyas.bhatewara/ResumeShreyasBhatewara.pdf ). =
I
> have been working on Linux/Solaris kernels, C, C++=C2=A0 professional=
ly and
> academically for some time now.
>=20
> Thanking you.
> Shreyas N Bhatewara
> --
> MS Comp Sci, UTD, Aug 2009
> BE Computer Engg, PICT, University of Pune.
> ------
> Luck favors them who work hard smartly and I like being lucky :>

Have you looked at nftables which is what the architecture netfilter de=
velopers
are interested in pursing as the next step?  There are lots of possibil=
ities for
smarter code generation for that.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
