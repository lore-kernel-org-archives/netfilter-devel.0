From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: RFC: Partial IP4 syntax
Date: Wed, 29 Sep 2004 10:55:23 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409291051190.11661@filer.marasystems.com>
References: <415A12AE.1060901@parknet.dk> <415A3263.7080708@xgendev.com>
	<415A4B4E.1080801@parknet.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Ben Efros <ben@xgendev.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Lodal <simonl@parknet.dk>
In-Reply-To: <415A4B4E.1080801@parknet.dk>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 29 Sep 2004, Simon Lodal wrote:

> What tools are passing IP's literally as full 32bits? I understand why 
> programs (especially in script languages) might do it internally, but between 
> programs?

IETF has not defined such ascii representation of IPv4 addresses, but the 
BSD libc inet_aton function does and this has been inherited by very many 
systems and tools.

This notation is being depreated as it does not serve a very useful 
purpose and can be somewhat confusing, but it exists and conflicting with 
it would be a bad idea.

> If it is really a problem I agree my scheme will break it. Could probably be 
> solved by changing the default to incomplete-at-beginning, so 10 = .10 = 
> 0.0.0.10.

Not without breaking existing "industry standards" on how IP numbers can 
be typed.

You could use 10. for the 10.0.0.0/8 network.

Regards
Henrik
