From: Patrick McHardy <kaber@trash.net>
Subject: Re: issue with the quota match
Date: Sun, 03 Apr 2005 20:20:58 +0200
Message-ID: <4250340A.8030104@trash.net>
References: <1112030055.6205.23.camel@localhost>
	<42491710.4090400@eurodev.net> <424979FC.8020005@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <424979FC.8020005@info-link.net>
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

Brad Fisher wrote:
> I had submitted a patch at one time that added an option to the quota 
> match to tell it to count the headers...  If anyone's interested I could 
> post it again (or you could try searching the list archive), but it is 
> probably a little dated at the moment since I haven't done any work on 
> it in quite a while...

This is _ip_-tables, so not counting the IP-header doesn't make much
sense too me. I would prefer makeing this the default behaviour, with
a warning in the help-text.

Regards
Patrick
