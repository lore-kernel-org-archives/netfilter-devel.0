From: Pablo Neira <pablo@eurodev.net>
Subject: Re: UNREPLIED ICMP packets & conntrack-tool
Date: Wed, 02 Nov 2005 16:55:26 +0100
Message-ID: <4368E16E.5020505@eurodev.net>
References: <Pine.LNX.4.63.0511021057010.17619@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.63.0511021057010.17619@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> It seems that second id=7289 is missing:
> 
> conntrack -L:
> icmp     1 28 src=192.168.0.33 dst=XXX.XXX.XXX.XXX type=8 code=0 id=7289
> packets=4 bytes=336 [UNREPLIED] src=XXX.XXX.XXX.XXX dst=192.168.0.33
> type=0 code=0 packets=0 bytes=0 mark=0 use=1
> 
> /proc/net/ip_conntrack:
> icmp     1 28 src=192.168.0.33 dst=XXX.XXX.XXX.XXX type=8 code=0 id=7289
> packets=4 bytes=336 [UNREPLIED] src=XXX.XXX.XXX.XXX dst=192.168.0.33
> type=0 code=0 id=7289 packets=0 bytes=0 mark=0 use=1

Fixed. AFAIK, the ICMP id doesn't make too much sense for an ICMP
connection that is not type 8 (ECHO), that's why I decided not to
display it. But it's a good a idea keeping the same classical output
that cat /proc/net/ip_conntrack does.

-- 
Pablo
