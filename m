From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: Modify an sk_buff from an NF_HOOK
Date: Tue, 1 Mar 2005 20:58:18 -0500
Message-ID: <876ef97a050301175865675641@mail.gmail.com>
References: <20050302015034.GA857@earth.dsh.org.uk>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: nf-devel <netfilter-devel@lists.netfilter.org>
To: Ian Norton <bredroll@darkspace.org.uk>
In-Reply-To: <20050302015034.GA857@earth.dsh.org.uk>
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

On Wed, 2 Mar 2005 01:50:34 +0000, Ian Norton <bredroll@darkspace.org.uk> wrote:
> Hi everyone,
> 
> I've been faffing about for well over two weeks now, and, have come almost to
> the conculsion (as I hauntingly suspected) that 'any' changes to an skb that
> involve changes outside of the original values of skb->head and skb->tail are
> impossible to do safely.

No its not. How about some code, buddy? What exactly are you doing and
where are you doing it?

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
