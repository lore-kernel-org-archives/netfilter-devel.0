From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] Amanda conntrack/nat module update
Date: 02 Nov 2002 14:45:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1036244727.28830.66.camel@tux>
References: <20021101232337.GD16306@pc.ilinx>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@interlinx.bc.ca
In-Reply-To: <20021101232337.GD16306@pc.ilinx>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2002-11-02 at 00:23, netfilter@interlinx.bc.ca wrote:
> Hello Harald and friends,
> 
> Please find attached an update patch to patch-o-matic for my Amanda
> protocol conntrack/nat helper.  This patch corrects a minor error in
> the Config.in indentation as well as, and more importantly, lengthens
> the timeout for the master Amanda connection from the default UDP
> stream timeout (normally 180 seconds) to 300 seconds.
 
> I would be most appreciative if you could apply this patch to
> patch-o-matic at your earliest convenience.

Applied,

Thanks
-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
