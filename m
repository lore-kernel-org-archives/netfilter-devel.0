From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: Counter problem in a new nat target.
Date: Tue, 09 Dec 2003 15:48:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD5D294.3010701@netlab.hut.fi>
References: <Pine.LNX.4.44.0312091107570.24092-100000@filer.marasystems.com>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

>Do you really need to decrease the counters?
>
Well yes. My goal is to have a precise count of the connections that are 
not assured per destination host. I think I will try the helper option.

One more question: is the target function called for each new packets or 
only once per conntrack? I think I read somewhere that it was the first 
option but I cannot remember exactly and I cannot retrieve it.

Thanks a lot for your help,

         Emmanuel
