From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] unidirectional NAT
Date: Wed, 5 Jun 2002 11:48:49 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206051139230.8715-100000@blackhole.kfki.hu>
References: <20020605093650.GA9723@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <20020605093650.GA9723@balabit.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 5 Jun 2002, Balazs Scheidler wrote:

> The only features for an UDP proxy is the following:
> * being able to receive frames originally destined elsewhere (the REDIRECT
>   case)
> * being able to receive frames from an arbitrary host, originally destined
>   to another arbitrary host (the foreign address listen case)
> * being able to send frames using an arbitrary source IP/address, to an
>   arbitrary host (the foreign connect case)
>
> I use the NAT framework to redirect packets to the local stack, but as a
> sideeffect NAT translates replies as well.
>
> Now I don't want reply translation :), that's why the subject unidirectional
> NAT, which would mean to translate packets in only one direction. (to be
> honest the best would be to translate a single packet only)
>
> I'm thinking about two possibilities:
>
> * yet another flag to ip_nat_setup_info() to set up a single manip only.
> * free the state associated to UDP packets after the translation was applied.
> * instead of setting up a NAT translation, call manip_pkt() directly somehow

I'd combine the third with the new table I wrote about some months ago
(working name for the table is 'raw' instead of 'notrack' or 'select').
The proposed new target for the table is 'NOTRACK' so that the selected
packet would be skipped by conntrack and NAT as well. If I understand your
problem correctly, a target 'NONAT' could then be easily added and you
could call manip_pkt as you wish.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
