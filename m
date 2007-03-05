From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.20: ipt_owner match and INPUT chain
Date: Mon, 05 Mar 2007 19:11:31 +0100
Message-ID: <45EC5D53.3070901@trash.net>
References: <200703020946.20765.thomas.jarosch@intra2net.com>
	<200703021359.35886.thomas.jarosch@intra2net.com>
	<45E9A144.1050600@trash.net>
	<200703051806.13996.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200703051806.13996.thomas.jarosch@intra2net.com>
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

Thomas Jarosch wrote:
> On Saturday, 3. March 2007, Patrick McHardy wrote:
> 
>>>The easier solution would be to patch the socks server to execute a
>>>script if the client requests to bind a port on the server. The
>>>connection could be added via the userspace conntrack tool, right?
>>
>>That should work. We could also add support for helperless expectations
>>for this, which will properly deal with NAT automatically.
> 
> 
> I'm not sure if I understand you correctly, shouldn't it already be possible 
> to add an expectation via "conntrack -I expect"?

Yes, but currently expectations always need a master connection
with a helper assigned.

> Another idea came to my mind today: If the socks server needs to be patched 
> anyway, would it be useful to set a connmark via an ioctl on the socket?

connmark isn't possible since the sending side of the socket
only deals with packets before the have been associated with
a conntrack entry. But you could use normal marks, IIRC
Balazs Scheidler <bazsi@balabit.hu> posted a patch for this
to netdev about 1.5 years ago.

> Normal firewall rules could then be used for incoming and especially
> outgoing connections from the socks server.

Incoming connections don't work, the receiving socket is not known
while the packet is handled by netfilter.
