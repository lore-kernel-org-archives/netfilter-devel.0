From: DarKRaveR <DarKRaveR@habitat-b.de>
Subject: Re[2]: http&rtsp kernel 'proxy'
Date: Thu, 2 Oct 2003 19:22:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1196876201.20031002192241@habitat-b.de>
References: <200310021145.10243.fjcabello@visual-tools.com>
 <1268892368.20031002141507@habitat-b.de>
 <200310021531.33972.fjcabello@visual-tools.com>
Reply-To: DarKRaveR <DarKRaveR@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Francisco Javier Cabello Torres <fjcabello@visual-tools.com>
In-Reply-To: <200310021531.33972.fjcabello@visual-tools.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Francisco,

I think that's a question for the 'hardcore' iptable hackers ...
I am not really sure about this, sorry ...
Another thought: If both clients start sending the first data/string,
the extended string match might be a simple solution for you,
concerning http, the client starts with GET etc. ... RTSP I don't
know, but with this you could redirect the first packet. the question
is, if connection tracking helps you to handle all following packets
for this connection ...
I wonder, if any CORE iptables guy might be able to help you with this
...


Thursday, October 2, 2003, 3:31:33 PM, you wrote:

FJCT> Hello,
FJCT> thanks for your reply.
FJCT> RTSP protocol is similar to HTTP. There are some situations where server may 
FJCT> start a connections, but not in my environment.
FJCT> If I have understood it, I have to implement two 'matches', one of then for 
FJCT> RTSP and the other one for HTTP. With iptables I could add rules to redirect 
FJCT> rstp and http traffic to different ports. Should I modified iptables 
FJCT> application, by adding a dynamic library, in order to support new 'matches'?

FJCT> Regards,

FJCT> Paco


-- 
Best regards,
 DarKRaveR                            mailto:DarKRaveR@habitat-b.de
