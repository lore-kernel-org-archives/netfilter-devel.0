From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Fri, 21 May 2004 18:07:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AE2929.4040408@trash.net>
References: <Pine.LNX.4.44.0405211156380.22237-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira <pablo@eurodev.net>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0405211156380.22237-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:
> On Fri, 21 May 2004, Patrick McHardy wrote:
> 
> 
>>It should be, on x86 set_bit locks the bus:
> 
> 
> Which was my second question.. does this set_bit really need to be atomic 
> with a memory barrier?

I missed that question. It's probably not neccessary, we will get a
small race when zapping conntracks, but according to this comment in
unreplied() we already have one anyway.

/* There's a small race here where we may free a just-assured
    connection.  Too bad: we're in trouble anyway. */

Not sure if it's still correct, though.

Regards
Patrick

PS: As it turns out, I won't be gone over the weekend like I wrote.
