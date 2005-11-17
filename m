From: manish popli <popli_manish77@yahoo.com>
Subject: Re: Re[2]: how to install time patch
Date: Thu, 17 Nov 2005 05:02:31 -0800 (PST)
Message-ID: <20051117130231.81944.qmail@web53610.mail.yahoo.com>
References: <Pine.LNX.4.64.0511171416150.20297@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org, mail@epfi.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0511171416150.20297@bizon.gios.gov.pl>
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

No it hasn't /proc/net/ip_tables_matches interface
but there is /proc/net/ip_mr_cache &
/proc/net/ip_mr_vif
can you tell me how to upgrade kernal ??


--- Krzysztof Oledzki <olenf@ans.pl> wrote:

> 
> 
> On Thu, 17 Nov 2005, manish popli wrote:
> 
> > I am fail to install time patch for iptables..
> > i have visited at
> >
> http://www.lowth.com/howto/add-iptables-modules.php
> >
> > but i m not able to doit successful..can any one
> guide
> > me how to install "libipt_time.so" under
> Enterprise
> > linux AS-3 (Linux version 2.4.21-4.ELsmp)..
> 
> Hm... To use -m time you need to have ip_time
> enabled kernel. This 
> 2.4.21-4.ELsmp smeems to be very old, I don't
> remember if it has 
> /proc/net/ip_tables_matches interface, is so please
> try:
> 
> grep '^time$' /proc/net/ip_tables_matches|wc -l
> 
> BTW, any chances for upgrading kernel?
> 
> Best regards,
> 
> 
>  				Krzysztof Olêdzki



		
__________________________________ 
Start your day with Yahoo! - Make it your home page! 
http://www.yahoo.com/r/hs
