From: Diego Woitasen <diegows@linux.org.ar>
Subject: Re: why every time that a rule is inserted/appended....
Date: Wed, 28 May 2003 18:26:09 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ED52971.8020604@linux.org.ar>
References: <3ED2887B.5050807@linux.org.ar> <20030528183045.GB12978@naboo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

If you are talking about iptables2, I saw that and the change seems to 
me really interesting, but the project seems to be stopped.
I want to help the development of this new version, as soon as has time 
(soon I hope).

Where can i get the kernel interface? ...if exists...


> On Mon, May 26, 2003 at 06:34:51PM -0300, diegows wrote:
> 
>>...the entire table is replaced?
> 
> 
> the idea was to have an atomic snapshot from the kernel, which is
> especially important for the counters.
> 
> ipchains doesn't read a chain atomically and thus packets are still
> traversing between rules are being read from the kernel.  This leads to
> inconsistencies in 
> 
> 
>>If this could be better, advise me and i try to patch that.
> 
> 
> Sure it can be done better, and there have been at least two approaches
> to introduce a new kernel/userspace interface, both based on nfnetlink.
> 
> However, this is not a 'small patch' but a fundamental design change.
> 
> [maybe I'll finally find some time to do pkttables stuff again... but
> now there is lots of other distracting stuff like that dual opteron box
> ;)]
> 
