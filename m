From: Max Kellermann <max@duempel.org>
Subject: Re: Basic linux firewall
Date: Tue, 8 Mar 2005 17:36:33 +0100
Message-ID: <20050308163633.GA17411@roonstrasse.net>
References: <200503081526.32310.scarab@echostar.pl>
	<20050308144449.GA16532@roonstrasse.net>
	<485E90C0FDC6332D1BE8AE68@[10.169.6.246]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Kenneth Porter <shiva@sewingwitch.com>
Content-Disposition: inline
In-Reply-To: <485E90C0FDC6332D1BE8AE68@[10.169.6.246]>
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

On 2005/03/08 17:27, Kenneth Porter <shiva@sewingwitch.com> wrote:
> > http://ferm.foo-projects.org/
> 
> That's pretty slick. Can it generate iptables-save files and generate ferm 
> files from an existing iptables-save file? I've been maintaining my rules 
> in that format because that's what Fedora uses to reload the tables at boot 
> time.

No. but you can call ferm to generate new rules, and then call
iptables-save yourself if you really want it.

The idea of ferm is that you call "ferm /etc/ferm.conf" on bootup from
an init script, so you don't need iptables-save.

Max
