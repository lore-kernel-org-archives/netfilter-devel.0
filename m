From: Patrick McHardy <kaber@trash.net>
Subject: Re: Ctnetlink?
Date: Tue, 04 Nov 2003 01:40:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FA6F588.9060406@trash.net>
References: <661F9268BBA8CB4EB92CC12B8C42F06912ECA0@pluto.rovingplanet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Paul Albert <palbert@rovingplanet.com>
In-Reply-To: <661F9268BBA8CB4EB92CC12B8C42F06912ECA0@pluto.rovingplanet.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Paul Albert wrote:

>Is the only way to learn more about this to apply it through the POM and
>check out some of the code?  I would like to learn more, but I'm not
>sure how to go about this ...
>
>Much thanks,
>Paul
>  
>

You can find some incomplete but partial working code at
http://trash.net/~kaber/ctnetlink (ct.tar.gz I believe).
It's a command-line tool I used for testing ctnetlink.
It also includes a ctnetlink monitor. It's probably enough
for a start but beware that ctnetlink interface is not
stable at all and may change any minute ;) Most stuff
that is currently in place will probably stay, but you
never know ..

Best regards,
Patrick
