From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: PATCH: fix invert flag on match mac save
Date: 14 Jun 2003 16:28:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1055600939.15668.77.camel@tux.rsn.bth.se>
References: <3EDA3916.3090604@alfar.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Dave <dave@alfar.co.uk>
In-Reply-To: <3EDA3916.3090604@alfar.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2003-06-01 at 19:34, Dave wrote:
> Hi there,
> 	I've been having problems using iptables-restore with the match mac 
> extension, which I narrowed down to the position of the invert flag on 
> save. Looks like this one's been hanging around for a while now.

I applied a slightly modified version, thanks.

-- 
/Martin
