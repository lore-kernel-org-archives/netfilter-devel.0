From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: differences between win and unix tcp clients.
Date: Wed, 17 Mar 2004 05:31:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87wu5kp2s4.fsf@aka.i.naked.iki.fi>
References: <024b01c40b4f$e3341620$3f32a8c0@ds.ig.com.br> <courier.40572942.00001232@ma.rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

netfilter-devel@rtij.nl wrote:
> Fabiano Reis writes:
>> Conclusion: I think this was because the Windows implementation of
>> TCP detects something different on this connection, maybe it
>> detects in some way that there is a filter on the server side and
>> this is why the time for the error message take so long to
>> appear. Am I right? Is there a workaround for this problem? I need
>> to make windows think that the server is really "down" and that is
>> why i´m writting to you people.
>
> You are right, tcp/ip stacks are different. In this the difference
> shows case the filtered port will send back a host-unreachable while
> the closed port will send back a TCP-reset. It is best to always
> send back a TCP reset when rejecting tcp, all stacks react good to
> this (they better do, it's in the RFC). So add a --with-tcp-reset to
> jour reject and you should be OK.

Send TCP reset if you wish to get immediate response.

TCP/IP stacks which interrupt connection attempts on ICMP
host-unreachable are broken implementations. ICMP messages are
advisory and insecure. The message shown, host unreachable, is merely
advisory - the actual thing the machine is telling you is that the
connection timed out and that in _addition_ a host unreachable message
was received during the timeout which might very well be related, but
which is not definitive.

-- Naked
