From: Kenneth Porter <shiva@sewingwitch.com>
Subject: Re: Basic linux firewall
Date: Tue, 08 Mar 2005 09:07:03 -0800
Message-ID: <F3ADB2E8F8A50E9A4A16D308@[10.169.6.246]>
References: <200503081526.32310.scarab@echostar.pl>
	<20050308144449.GA16532@roonstrasse.net>
	<485E90C0FDC6332D1BE8AE68@[10.169.6.246]>
	<20050308163633.GA17411@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050308163633.GA17411@roonstrasse.net>
Content-Disposition: inline
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

--On Tuesday, March 08, 2005 5:36 PM +0100 Max Kellermann <max@duempel.org> 
wrote:

> No. but you can call ferm to generate new rules, and then call
> iptables-save yourself if you really want it.

I mention iptables-save as an output format because it's been mentioned 
here that it's more efficient than individual iptables commands for 
building large firewalls. I think that's because it results in one kernel 
call instead of a multitude, and a lot less lock manipulation to add all 
the rules. The format is relatively simple and could easily be constructed 
from individual rule commands, so it's probably straightforward to add.

> The idea of ferm is that you call "ferm /etc/ferm.conf" on bootup from
> an init script, so you don't need iptables-save.

That makes sense. I was mostly thinking of the case where one already has a 
firewall produced with some other tool (or constructed by hand). Being able 
to reverse that into a ferm.conf file would allow people using other tools 
to easily migrate.
