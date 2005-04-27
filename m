From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Wed, 27 Apr 2005 12:27:46 +0200
Message-ID: <426F6922.6030105@trash.net>
References: <20050402202438.GA2968@linuxace.com>	 <4250435E.1090309@trash.net>
	<20050403235320.GB28850@linuxace.com>	
	<20050404044033.GA1847@linuxace.com> <4250FA72.3020502@trash.net>
	<1114562640.24187.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1114562640.24187.9.camel@localhost.localdomain>
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

Rusty Russell wrote:
> Please enhance nfsim-testsuite with these.  I dislike adding new hooks,
> but to be honest I haven't had time to follow this conversation.  At
> least a testcase will allow us to vet other solutions, and prevent us
> from breaking this again.

I don't like adding hooks either, but it was the safest fix for 2.6.12.
I'll try to add the tests when I find some time, but first I need to
get nfsim to run properly on my 64bit machine.

Regards
Patrick
