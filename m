From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: deleting a conntrack record
Date: Thu, 17 Jun 2004 07:43:04 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <876ef97a0406170443202629c8@mail.gmail.com>
References: <876ef97a04061704395e51d327@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: nf-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <876ef97a04061704395e51d327@mail.gmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 17 Jun 2004 07:39:50 -0400, Tobias DiPasquale
<codeslinger@gmail.com> wrote:
> So, is there a cleaner way to hand-delete a conntrack record? Or is
> this the only method? Or is there some error in the way that I am
> doing the above?

I forgot to mention that the driver for this is a script that will
read the conntrack entries out of /proc/net/ip_conntrack and then
delete entries that are "stale" (i.e. been too long since we've seen a
packet) by passing their information into my /proc interface. The
script runs from cron every 5 minutes.

Thanks!

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
