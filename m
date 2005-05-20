From: Max Kellermann <max@duempel.org>
Subject: Re: the latest h323 module doesn't build.
Date: Fri, 20 May 2005 13:50:38 +0200
Message-ID: <20050520115038.GA9057@roonstrasse.net>
References: <200505201342.27652.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <200505201342.27652.pluto@agmk.net>
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

On 2005/05/20 13:42, Pawel Sikora <pluto@agmk.net> wrote:
> gcc4 reports an error:
> 
>   CC [M]  net/ipv4/netfilter/ip_conntrack_standalone.o
> In file included from net/ipv4/netfilter/ip_conntrack_standalone.c:34:
> include/linux/netfilter_ipv4/ip_conntrack.h:161:
> error: field 'ct_h225_info' has incomplete type
> 
> i don't see a definition of ip_ct_h225_master struct
> in svn/linux-2.6.11 subdir. `rm ip_conntrack.h.ladd` fixes problem.

Correct. Patrick forgot to delete the file when he applied my patches
which I published on May 10th.

Max
