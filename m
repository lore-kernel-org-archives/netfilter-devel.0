From: Mircea Ciocan <mirceac@interplus.ro>
Subject: HELP: Conntrack table filling up !!!
Date: Mon, 23 Dec 2002 21:00:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E075D48.70801@interplus.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

	Hi everybody,

	I have this problem with connexion tracking table filling to the max 
and then it remains in a state "near the edge" that will allow only a 
small number of new conexions and will cause a large packet loss, even 
"sendto: operation not permited" sometimes when I ping the neighboor 
routers and so on.
	Everything got cleared up if I delete the ip tables rules that deal 
with contrack and remove and reinsert ip_conntrack module.
	Now if there is some method of avoiding this ( I only see a discution 
from 2001 that was not conclusive) or if there is is an method to 
time-out faster those conexions in conntrack table or even a method of 
globaly quick-flush that table ( could be a even an experimental patch, 
I'm willing to try it and report) I'd very muck like to hear about it.
	Anyhow, thank you for your good work and have a happy new year.
		
		Regards,

		Mircea Ciocan

P.S. kernel is 2.4.18 and machine have enough ram ( 512 MB) and 
processing power ( P-III 800MHZ), traffic is something like 50 Mb/s top 
ans 25-30 medium.
