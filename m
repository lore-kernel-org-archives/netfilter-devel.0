From: Max Kellermann <max@duempel.org>
Subject: Re: Basic linux firewall
Date: Tue, 8 Mar 2005 18:21:32 +0100
Message-ID: <20050308172132.GA17742@roonstrasse.net>
References: <200503081526.32310.scarab@echostar.pl>
	<20050308144449.GA16532@roonstrasse.net>
	<485E90C0FDC6332D1BE8AE68@[10.169.6.246]>
	<20050308163633.GA17411@roonstrasse.net>
	<F3ADB2E8F8A50E9A4A16D308@[10.169.6.246]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <F3ADB2E8F8A50E9A4A16D308@[10.169.6.246]>
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

On 2005/03/08 18:07, Kenneth Porter <shiva@sewingwitch.com> wrote:
> I mention iptables-save as an output format because it's been mentioned 
> here that it's more efficient than individual iptables commands for 
> building large firewalls.

sure, interesting idea: let ferm generate an iptables-save file
instead of calling iptables many times in a row. I'm writing that on
my todo list.

> That makes sense. I was mostly thinking of the case where one already has a 
> firewall produced with some other tool (or constructed by hand). Being able 
> to reverse that into a ferm.conf file would allow people using other tools 
> to easily migrate.

That's not as easy as it sounds - ferm is for structured firewall
rules, iptables is flat. But a simple (flat) back-translation could
provide a good starting point for a ferm migration.

Max
