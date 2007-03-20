From: "Robert Iakobashvili" <coroberti@gmail.com>
Subject: Re: bloom filter in netfilter?
Date: Tue, 20 Mar 2007 18:31:32 +0200
Message-ID: <7e63f56c0703200931h11d909c3td142f611be228e9b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

> You're right, tuple reuse is a problem, it seems counting bloom
> filters would be needed to deal with that, which are a lot less
> memory efficient. The increasing probabilities of false positives
> with increasing number of entries could be dealt with by using a
> second bloom filter that is filled with new entries once a low
> threshold is exceeded and replaces the active one once a high
> threshold is exceeded.
>
> I have to admit that I'm a huge fan of bloom filters and always
> wanted to use them for something cool :)

Recent paper from Luca Deri could be relevant here:
http://luca.ntop.org/Blooms.pdf

-- 
Sincerely,
Robert Iakobashvili,
coroberti %x40 gmail %x2e com
...................................................................
Navigare necesse est, vivere non est necesse
...................................................................
http://curl-loader.sourceforge.net
A powerful open-source HTTP/S, FTP/S traffic
generating, loading and testing tool.
