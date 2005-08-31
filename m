From: Kris <kris@theendless.org>
Subject: Re: Implementing --log-uid in to a 2.4.x kernel
Date: Wed, 31 Aug 2005 10:42:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.63.0508311041440.12743@morpheus.theendless.org>
References: <Pine.LNX.4.63.0508301507100.12743@morpheus.theendless.org>
	<4314DE54.20804@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4314DE54.20804@trash.net>
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

I've actually ported it.  It was quite simple.  Should I post the patch 
anywhere?  I'm not sure what the protocol is for this sort of thing.  Is 
anyone interested in it?

Kris


On Wed, 31 Aug 2005, Patrick McHardy wrote:

> Kris wrote:
>> Hi,
>>     I'd like to implement this feature in to the 2.4.x kernel as it is
>> currently only supported in 2.6.x.  However, I would like to know if
>> anyone can shed some light on why it isn't already included?  Is this a
>> futile or difficult task?  I'd think that since there is already
>> owner-match support in 2.4.x it would be trivial to hack in the
>> --log-uid support as the information is obviously available to the
>> kernel and the netfilter API.  No?
>
> 2.4 is in pure maintenance mode, no new features are added. This is
> why the patch was only included in 2.6. The original patch should be
> trivial to port to 2.4.
>
