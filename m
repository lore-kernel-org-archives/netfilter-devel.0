From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: VLAN match within iptables
Date: Tue, 26 Jun 2007 12:00:55 +0200
Message-ID: <4680E3D7.6020401@netfilter.org>
References: <1182849745.22167.13.camel@blas>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>
To: Jaime Nebrera <jnebrera@eneotecnologia.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1182849745.22167.13.camel@blas>
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

Jaime Nebrera wrote:
>   We are seeking for a way to match rules based on VLAN Tag ID.
> 
>   Searching the archives I have found this post:
> 
> http://lists.netfilter.org/pipermail/netfilter-devel/2006-August/025336.html
> 
>   But the patch is missing and the answer was to use ebtables.
> 
>   Of course ebtables already has this and this is kinda redundant, but
> at the same time things get a bit complex when you have to worry about
> so many marks due to vlan id, ips stuff etc etc
> 
>   Is there any way to access the patch Amin sent to the list?

Since you have to apply that patch to your kernel anyway, I suggest you
to apply the u32 patch instead (it is scheduled for 2.6.23 IIRC).

http://lists.netfilter.org/pipermail/netfilter-devel/2007-June/028189.html
http://lists.netfilter.org/pipermail/netfilter-devel/2007-June/028176.html

Of course, you'll have to define the rule to match the vlan stuff but if
later on you need to match any other minor bit, you'll already have the
way to do so.

-- 
"Países en desarrollo es el nombre con que los expertos designan a los
países arrollados por el desarrollo ajeno" -- Patas Arriba. La Escuela
del Mundo al Revés -- E. Galeano
