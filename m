From: Kenneth Porter <shiva@sewingwitch.com>
Subject: Re: Basic linux firewall
Date: Tue, 08 Mar 2005 08:27:49 -0800
Message-ID: <485E90C0FDC6332D1BE8AE68@[10.169.6.246]>
References: <200503081526.32310.scarab@echostar.pl>
	<20050308144449.GA16532@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050308144449.GA16532@roonstrasse.net>
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

--On Tuesday, March 08, 2005 3:44 PM +0100 Max Kellermann <max@duempel.org> 
wrote:

> For writing rules, I recommend that you use ferm. Ferm is a frontend
> for iptables which makes writing rules really easy. I joined the
> project a few months ago.
>
>  http://ferm.foo-projects.org/

That's pretty slick. Can it generate iptables-save files and generate ferm 
files from an existing iptables-save file? I've been maintaining my rules 
in that format because that's what Fedora uses to reload the tables at boot 
time.
