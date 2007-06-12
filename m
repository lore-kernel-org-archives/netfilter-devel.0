From: Simon <simon.xhz@gmail.com>
Subject: Re: Follow packets in rules
Date: Tue, 12 Jun 2007 16:41:10 -0500
Message-ID: <f7de5e030706121441h6b817d82td49e3eb4346e5a12@mail.gmail.com>
References: <000001c7ad1c$9ccb09b0$1806380a@adidf.efs.sante.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Fabrice Rafart" <fabrice.rafart@efs.sante.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <000001c7ad1c$9ccb09b0$1806380a@adidf.efs.sante.fr>
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

On 6/12/07, Fabrice Rafart <fabrice.rafart@efs.sante.fr> wrote:
> Hello,

Salut Fabrice!

> I look for a tool to follow a packets into rules of netfilter.
[...]
> This show me which rules matches the packet until the end.

I'm not sure if such a tool exists, but there is a way to follow the
packets very well.
Using the LOG target, you can log packets as they match certain rules
and you can put a message to be put in the log to identify that line.

After, you just have to grep the logfile for patterns matching the ip
address and you should see the history of each packets that came in.

You could make your own target queues like LOGDROP or LOGACCEPT and
have a log rule followed by the drop/accept rule.

Note that logging things this way takes a lot of disk space and should
only be used in a lan for experimentation.

Good luck,
  Simon
