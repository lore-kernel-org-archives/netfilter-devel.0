From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: flushing conntrack-table
Date: Fri, 11 Mar 2005 19:51:41 -0500
Message-ID: <876ef97a05031116517b0a7f9e@mail.gmail.com>
References: <20050312003418.6a582ad9@coruscant>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Olaf Rempel <razzor@kopf-tisch.de>
In-Reply-To: <20050312003418.6a582ad9@coruscant>
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

On Sat, 12 Mar 2005 00:34:18 +0100, Olaf Rempel <razzor@kopf-tisch.de> wrote:
> I've build a modul to flush some/all conntracks from the ct-table, but have
> some questions about the used functions and locking issues.
> 
> I'm sending a "search pattern" (proto + srcip/mask + sport-range + dstip/mask
> + dport-range) via ioctl (yeah, i know..) to the kernel, and delete all matching
> conntracks.

This is in fact what the kill parameter to ip_ct_selective_cleanup()
was designed for. Check out its definition in ip_conntrack_core.c and
its usage later on in that same file in the ip_conntrack_cleanup()
function.

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
