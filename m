From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] cvs compile error.
Date: 05 May 2003 22:31:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1052166668.24216.2.camel@tux.rsn.bth.se>
References: <E19CliW-0004pJ-00@kashyyyk.netfilter.org>
	 <Pine.LNX.4.51.0305052144430.31233@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <Pine.LNX.4.51.0305052144430.31233@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2003-05-05 at 21:51, Maciej Soltysiak wrote:
> Hi,
> 
> it seems as:
> ipt_get_target(struct ipt_entry *e)
> 
> is defined in <kernel_source>/include/linux/netfilter_ipv4/ip_tables.h
> and in iptables.c
> 
> The same goes for libiptc/libiptc.c
> 
> iptables.c:153: redefinition of `ipt_get_target'
> /usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:294: `ipt_get_target' previously defined here
> make: *** [iptables.o] Error 1
> 
> Regards,
> Maciej
> 
> Is this below okay?
> It compiles with it, and seems to work just fine.

Please read
https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=82

-- 
/Martin
