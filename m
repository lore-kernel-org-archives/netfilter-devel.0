From: IP v6 <inet6@mail.be>
Subject: Re: raw/NOTRACK + TARPIT = good idea?
Date: Tue, 2 Dec 2003 05:38:44 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <14014030.1070339924765.JavaMail.Administrator@pumbaa>
References: <Pine.LNX.4.33.0311240903430.12476-100000@blackhole.kfki.hu>
Reply-To: IP v6 <inet6@mail.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.33.0311240903430.12476-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I would like to do this also but I don't quite understand what you mean with "take care both directions for the tarpitted sessions".

I'm a bit confused there, could you explain? :)

Wkr, Robby

> ----------------------------------------
> From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Sent: Mon Nov 24 09:11:17 CET 2003
> To: Juan Carlos Castro y Castro <jcastro@vialink.com.br>
> Subject: Re: raw/NOTRACK + TARPIT = good idea?
> 
> 
> On Fri, 21 Nov 2003, Juan Carlos Castro y Castro wrote:
> 
> > I'm thinking about the TARPIT target, and that it's a shame it will
> > use resources if my box does conntrack. But if I previously pass them
> > through -t raw -j NOTRACK, can I have the best of both worlds, i.e., a
> > routing NAT box who is able to tarpit undesired packets itself?
> 
> Yes, but you have to take care both directions for the tarpitted
> sessions. That's the price using the NOTRACK target.
> 
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : KFKI Research Institute for Particle and Nuclear Physics
>           H-1525 Budapest 114, POB. 49, Hungary
> 
> 
> 

-----------------------------------------------------
Mail.be, WebMail and Virtual Office
http://www.mail.be
