From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink questions
Date: Sun, 19 Oct 2003 21:36:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F92E7CD.3010607@trash.net>
References: <20031019171851.GR21521@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031019171851.GR21521@sunbeam.de.gnumonks.org>
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

>Hi Patrick!
>
>A couple of questions regarding your ctnetlink modifications:
>
>1) Why do we need this 'ordered list' ?  I can't remember the exact 
>   reason why it was added
>
The ordered list and the unique conntrack id was added for table 
dumping. Without
it entries could be dumped multiple times or even worse a single hash 
chain chould
be dumped over and over again if it's contents exceeded the size of a 
single skb.

>2) Why did you merge connmark and ctnetlink?  Was it just for
>   convenience? If yes, I'd appreciate to have them seperated again.
>
It's just a left-over .. I started hacking on ctnetlink to change 
connection marks
from userspace .. I'm going to remove it from the next patch.

Best regards,
Patrick

>
>Thanks.
>
>  
>
