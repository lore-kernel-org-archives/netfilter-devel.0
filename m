From: Patrick McHardy <kaber@trash.net>
Subject: Re: libipq, kernel panics/oopses, and other undesirable traits
Date: Thu, 19 Aug 2004 16:13:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4124B59E.4060701@trash.net>
References: <E1BwO5M-000718-NF@giant.mindlink.net> <1092692707.22731.1687.camel@marx.mindlink.net> <41213777.9050701@trash.net> <1092703243.22731.1778.camel@marx.mindlink.net> <4121E082.6050602@trash.net> <1092775215.22731.1958.camel@marx.mindlink.net> <20040819105533.GI3921@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Matt Walters <mattw@parasun.com>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040819105533.GI3921@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>On Tue, Aug 17, 2004 at 01:40:15PM -0700, Matt Walters wrote:
>  
>
>>Thanks Patrick-
>>
>>	A quick test shows that unaltered packets being passed back from
>>userspace no longer cause kernel panics (yay) but also that they are not
>>being responded to (boo).  I'll have a look deeper into it later on.
>>    
>>
>
>Patrkick, do you think we should push your make_writable fix to davem
>yet?
>  
>

No, let's wait until we know what's causing Matt's problems.

Regards
Patrick
