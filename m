From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re:Re[2]: REJECT target
Date: Thu, 26 Jun 2003 15:12:47 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306260512.h5Q5CnS08017@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "DarKRaveR" <DarKRaveR@habitat-b.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello DarKRaveR,

  I agree with trying to filter on the prerouting chain .. and I think that
comes from using netfilter as a standalone firewall rather than using
it as a host-based firewall.  I prefer to see packets stopped at the first
point capable of making the decision, and that's at the prerouting chain.
I believe I stand alone on that, though.

  However, I use drops in all of my rules, so I've not come across the
reject problem.  I don't know why reject couldn't be applied to any
chain .. isn't this just an "or" option in the target module?  Is there any
other reason (list)?



----- Original Message -----
>From: "DarKRaveR" <DarKRaveR@habitat-b.de>
>To: <netfilter-devel@lists.netfilter.org>
>Subject:  Re[2]: REJECT target
>Date: Wed, 25 Jun 2003 16:13:43 +0200
>
> Hello Jozsef,
> 
> I understood that, the question is why ? I got a scenarion, where I
> would need it in the PREROUTING chain of the nat table, instead of
> just dropping the packets ... Is there any reason, why it is only
> available in the filter table. I mean, it's for filtering okay, but
> maybe I want to reject connections properly at other places (like nat
> table, prerouting) instead of plain stupid
> dropping them and waiting at the client software to time out.
> 
> Wednesday, June 25, 2003, 9:17:56 AM, you wrote:
> 
> JK> On Wed, 25 Jun 2003, DarKRaveR wrote:
> 
> >>   I know this is not really a developers question, but maybe the
> >>   developers are the right people at hand, to explain this.
> >>   From what I read, the REJECT target is only valid in
> >>   INPUT/OUPUT/FORWARD. Is there any particular reason why ? I read in
> >>   one of the tutorials, that you wouldn't need it at any other place,
> >>   but I think this is not perfectly true.
> 
> JK> The REJECT target is for filtering. The filter table has got the
> JK> INPUT/OUPUT/FORWARD chains, therfore the REJECT target can be used in
> JK> those chains (and sub-chains, naturally).
> 
> JK> Best regards,
> JK> Jozsef
> JK> -
> JK> E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
> JK> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> JK> Address : KFKI Research Institute for Particle and Nuclear Physics
> JK>           H-1525 Budapest 114, POB. 49, Hungary
> 
> 
> 
> 
> -- 
> Best regards,
>  DarKRaveR                            mailto:DarKRaveR@habitat-b.de
> 
> 
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
