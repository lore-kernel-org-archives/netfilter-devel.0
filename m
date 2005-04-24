From: Wang Jian <lark@linux.net.cn>
Subject: Re: --in-interface and --out-interface issue on bridge
Date: Mon, 25 Apr 2005 01:05:26 +0800
Message-ID: <20050425005137.9381.LARK@linux.net.cn>
References: <20050421151458.03C6.LARK@linux.net.cn>
	<426BC921.1080403@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <426BC921.1080403@trash.net>
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

Hi Patrick McHardy,

Thanks a lot for your hint.

Just in curiousness: when and why the -i and -o don't match on bridge's
physic device? A lot of documents on bridging firewall give example
using -i and -o.

On Sun, 24 Apr 2005 18:28:17 +0200, Patrick McHardy <kaber@trash.net> wrote:

> Wang Jian wrote:
> > Hi,
> > 
> > During my test, I find that --in-interface doesn't work as I expected.
> > 
> >   web server -- (eth0--br0--eth1)  -- web client
> > 
> > 
> > # iptables -t mangle -A PREROUTING -i eth0 -p tcp --sport 80 \
> > 	-j MARK --set-mark 1
> > 
> > doesn't set mark to 1.
> 
> Find out which interface is used using LOG. There is a physdev-match
> for use with briding, perhaps this is what you need.
> 
> Regards
> Patrick



-- 
  lark
