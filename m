From: Pablo Neira <pablo@eurodev.net>
Subject: Re: libipq question
Date: Fri, 25 Jun 2004 22:38:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40DC8D36.2000209@eurodev.net>
References: <A516FD6F11040F4E881C92EDA23F31A802ACF8AE@mx1.bsafeonline.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: spanishmack@mchsi.com,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <A516FD6F11040F4E881C92EDA23F31A802ACF8AE@mx1.bsafeonline.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Steve,

Steve Ashley wrote:

>I'm using libipq to do some user-space filter stuff.  Everything is
>working great and for my application, I'm not taking a significant
>enough speed hit to warrant making a new target, iptables kernel module.
>However, I am getting one problem.  If my application runs for a long
>time ( i.e. several hours or overnight ) with no activity, then filters
>packets.  I'm getting the following error messages:
>
>Error in recv().
>Broken pipe.
>  
>

If I'm not missing anything, I think that you could set the handler of 
the broken pipe signal to an empty function, this way the application 
won't exit.

>Currently I'm using the blocking version of the ipq_read() function,
>with no timeout.  Would putting a timeout here, and checking on the
>netlink socket every so often be a good idea?  Any thoughts or ideas
>would be helpful.
>  
>

Well, you could even use select() to check when the descriptor has new 
data ready to be read. I was told (Richard Steven's books) that 
polling+non blocking sockets are always faster than blocking sockets.

>Also, just for information sake.  At some point, if I add more features
>into my application, I fear using a userspace application may not be
>sufficient.  Where can I find a good example of a new netfilter target
>kernel module code?
>

you want to program a match/target, you can have a look at the 
netfilter-hacking howto:

http://www.netfilter.org/documentation/index.html#documentation-howto

and also you can have a look at source code in kernel and iptables 
trees, there are simple matches/targets.

On the other hand, I suppose that you meant that you wanted to know how 
to add a hook to netfilter, in that case have a look at:

http://www.linuxjournal.com/article.php?sid=7184

I passed that linuxjournal to a friend and he didn't have big problems 
to program a simple hook.

regards,
Pablo
