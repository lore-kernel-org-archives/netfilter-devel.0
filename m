From: Max Kellermann <max@duempel.org>
Subject: Re: Basic linux firewall
Date: Tue, 8 Mar 2005 15:44:49 +0100
Message-ID: <20050308144449.GA16532@roonstrasse.net>
References: <200503081526.32310.scarab@echostar.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: scarab@echostar.pl
Content-Disposition: inline
In-Reply-To: <200503081526.32310.scarab@echostar.pl>
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

On 2005/03/08 15:26, scarab@echostar.pl wrote:
[...]
> Could anybody give me some information where can i find some
> documents, books or something like that about how to start etc? I
> knew that propably somebody asked for that here before and I tried
> to find something in netfilter-devel archive but i didn't success.

Have you already tried the documentation on the netfilter home page?

 http://www.netfilter.org/documentation/

For writing rules, I recommend that you use ferm. Ferm is a frontend
for iptables which makes writing rules really easy. I joined the
project a few months ago.

 http://ferm.foo-projects.org/

Max
