From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: H.323 progress.
Date: Wed, 19 May 2004 08:14:17 +1200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AA6E99.20900@sauce.co.nz>
References: <40A9431D.8020404@sauce.co.nz> <2291.1084889170@marajade.sandelman.ottawa.on.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <2291.1084889170@marajade.sandelman.ottawa.on.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Michael Richardson wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> 
> 
> 
>>>>>>"Richard" == Richard Scobie  writes:
> 
>     Richard> I have a FreeSwan IPsec VPN between 2 iptables NAT boxes.
> 
>   Okay. But this, you mean that you have two boxes that normally perform
> NAT, but the VPN otherwise connects the two private networks? (I am
> asking to confirm this)

Two offices each with an iptables firewall and a site to site VPN 
between them - the video gear is configured to connect to each others 
private network address through the VPN.

>     Richard> With H.323 videoconferencing equipment from both Via Video
>     Richard> and Tandberg, I have been unable to get complete connection
>     Richard> between both ends through the VPN - 90+ % of the time,
>     Richard> video connects both ways and audio only one.
> 
>   I'm ignorant of how the proxies work. If you have a VPN, why do you
> need them?  I'd think you need them only when trying to pass through the
> NAT, rather than go around it.

I think the proxies are required to negotiate the correct call setup, 
because the iptables H.323 helper modules (which are still required in 
this setup as NAT is involved), as Jozsef mentioned above, do not always 
get it right.

Richard
