From: shah hemal <hshah127@yahoo.com>
Subject: Re: nf_mark use in sk_buff
Date: Tue, 13 Feb 2007 02:48:42 -0800 (PST)
Message-ID: <344957.1159.qm@web36514.mail.mud.yahoo.com>
References: <20070212.122227.104035723.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212.122227.104035723.davem@davemloft.net>
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

Dear sir,

     thanks for reply.I have register netfilter hook 
NF_IP_FORWARD and wrote the handler function

 i want to forward the packet from my local buffer
where i have cached it. i saw one field in skbuff
structure. i.e. nfmark.

Is it possible to pass the mark value to module and
then use it to point  skbuff->nfmark?this mark can be
any integer value ??

thanks in advance.
hemal





--- David Miller <davem@davemloft.net> wrote:

> From: shah hemal <hshah127@yahoo.com>
> Date: Sun, 11 Feb 2007 00:20:25 -0800 (PST)
> 
> > Hi,
> > 
> >           What is nfmark field of sk_buff? For
> what
> > purpose it can be use?
> > 
> > its written in sk_buff structure description:
> > nfmark
> > 
> >     Can be used for communication between hooks .
> 
> You can set the mark one rule, then match on the
> mark using other
> rules.
> 
