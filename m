From: Clifford Wolf <clifford@clifford.at>
Subject: Re: iptables -m mac, --mac-dst support.
Date: Tue, 27 Dec 2005 16:41:05 +0100
Message-ID: <20051227154105.GA18029@clifford.at>
References: <1924670592.20051225023536@vkt.lt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jarek <hugle@vkt.lt>
Content-Disposition: inline
In-Reply-To: <1924670592.20051225023536@vkt.lt>
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

On Sun, Dec 25, 2005 at 02:35:36AM +0200, Jarek wrote:
> I was wondering if there is somewhere around a patch to support MAC
> based not on source but on destination. ? Cause I'd like to check if
> dst ID and dst MAC are x.x.x.x and zx:as:qw:zx:as:qw
> 
> If yes maybe you could share it, and if no.. any ideas if it's going to
> show up or maybe not at all?

Use 'ebtables -d'. Note that the destination MAC is only available in the
POSTROUTING chain.

-- 
 _  _       _      Nerds on Air - Radio for Geeks      _  __     ___
| \| |___  /_\   On 1st and 3rd Friday of the month   / |/ /__  / _ |
| .` / _ \/ _ \    21:00-22:00 CET on Radio Orange   /    / _ \/ __ |
|_|\_\___/_/ \_\     http://www.clifford.at/noa/    /_/|_/\___/_/ |_|
 
"Paranoia is faith in a hidden order behind the visible."
-- pi, the movie
 
