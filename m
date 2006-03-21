From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [RFC][PATCH] use of pkg-config in libnetfilter_*, conntrack,
 and ulogd2
Date: Tue, 21 Mar 2006 02:50:56 +0100
Message-ID: <441F5C00.2060206@eurodev.net>
References: <200603192324.50444@krak>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@sch.bme.hu>
In-Reply-To: <200603192324.50444@krak>
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

Hi Krisztian,

KOVACS Krisztian wrote:
>   This weekend I've spent a significant amount of time configuring and 
> compiling the whole libnetfilter_* universe and the conntrack and ulogd2 
> tools. My initial plan was to install everything under /opt/netfilter, 
> however, the out-of-the-box configure.in files provided with these 
> modules do not make this particularly easy.
> 
>   So after spending some time trying all kinds of mantras and magical 
> runes to get autoconfuse do what I intended to do, I came to the 
> conclusion that all this would be much simpler if we used the PKG_CHECK_* 
> macros in configure.in. The necessary pkgconfig .pc files are generated 
> and installed anyway, so why not?
> 
>   Of course this means that to compile these modules one will need 
> pkg-config, but personally I don't consider this a problem. The 
> additional benefit of this method would be that the only thing to take 
> care of is that of setting a correct PKG_CONFIG_PATH, all the include 
> paths and libraries are then found magically.

I like it, AFAIK pkg-config is always in most distros, so this new 
requirement shouldn't be a problem. Moreover, this provides us a way to 
easily maintain the library version dependencies. Since this also 
affects other libraries, I'll wait for Harald's ACK before commiting 
this to conntrack and libnetfilter_conntrack.

cheers,

--
Pablo
