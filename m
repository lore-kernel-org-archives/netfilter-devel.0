From: Patrick McHardy <kaber@trash.net>
Subject: Re: libipt_geoip.c doeasn't build with 2.6.12+conntrack-event-api.
Date: Fri, 05 Aug 2005 12:53:39 +0200
Message-ID: <42F34533.5070007@trash.net>
References: <200508042142.27778.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pawel Sikora <pluto@agmk.net>
In-Reply-To: <200508042142.27778.pluto@agmk.net>
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

Pawel Sikora wrote:
> Hi,
> 
> The conntrack-event-api patch removes from 2.6.12
> the NFC_* entries from linux/netfilter.h.
> finally geoip userspace module doesn't build.
> 
> Could someone netfilter guru fix this?

The latest event API (with this problem fixed) is in Dave's net-2.6.14
tree. I doubt anyone will continue updateing the version in pom.
