From: Max Kellermann <max@duempel.org>
Subject: Re: [RFC] h323 module unloading fix
Date: Tue, 8 Feb 2005 16:55:27 +0100
Message-ID: <20050208155527.GA31418@roonstrasse.net>
References: <20050208145908.GS6878@sunbeam.de.gnumonks.org>
	<20050208152620.GA30780@roonstrasse.net>
	<20050208155238.GT6878@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <20050208155238.GT6878@sunbeam.de.gnumonks.org>
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

On 2005/02/08 16:52, Harald Welte <laforge@netfilter.org> wrote:
> Yes, but every additional entry in the list of helpers is matched
> against every packet...  and I don't want to waste performance just for
> being a bit more clean.
> 
> But maybe we could add a flag to the helper like F_DISABLED which would
> disable matching for that particular helper.

That flag could be determined automatically in the register function
by looking at the mask.

Then the helper could be inserted into another list, which is only
used in the unregister function for cleanup. This way, the netfilter
core does not even have to traverse these helpers in the list to check
the "disabled" flag.

Max
