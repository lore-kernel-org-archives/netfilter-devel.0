From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: tcp window tracking question
Date: Thu, 16 Dec 2004 08:09:19 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412160809040.27232@filer.marasystems.com>
References: <00f901c4e21c$452634f0$0e25fe0a@pysiak>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <00f901c4e21c$452634f0$0e25fe0a@pysiak>
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

On Tue, 14 Dec 2004, Maciej Soltysiak wrote:

> Is the tcp window tracking code in effect only when ip_conntrack is loaded
> or regardles of ip_conntrack?

Only when loaded.

Regards
Henrik
