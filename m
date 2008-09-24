From: Philip Craig <philipc@snapgear.com>
Subject: Re: Conntrack flow expirations
Date: Wed, 24 Sep 2008 18:17:01 +1000
Message-ID: <48D9F77D.90005@snapgear.com>
References: <877i929hfi.fsf@galois.botik.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Alexey Mikhailov <karma@galois.botik.ru>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <877i929hfi.fsf@galois.botik.ru>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Alexey Mikhailov wrote:
> Hello!
> 
> I'm working on some accounting application based on connection tracking
> subsytem. Basically, i just gather information from expired flows. But
> there's problem, any TCP flow can live for 4 or 5 days for example, and
> I need to get more or less real-time processing. So I want to have some
> expiration mechanism. I need to:
> 
>  a) I don't want flows to live more than 30 minutes
>  b) If flow is inactive for 15 secs I want to get it expired as well

Unless you have a very specific traffic profile, both of these limits
are far too low.

> So here comes my question, how do I specify expiration time-out for
> long lived flows? I have found 
> 
> net.ipv4.netfilter.ip_conntrack_tcp_timeout_established = 5 DAYS

(While it will work, that sysctl is just for backwards compat.
Use net.netfilter.nf_conntrack_tcp_timeout_established instead.)

That setting is the inactive timeout, not the maximum duration.
There is no way to specify a maximum duration that I know of.  You
could get your accounting application to delete them after the maximum
duration.  eg using nfctnetlink or the conntrack userspace tool.

Also note that if you want to enforce a maximum duration, you'll
need to disable nf_conntrack_tcp_loose, otherwise the conntrack will
just get created again on the next packet.

> If I will change it to 30 MINS will it make trick? But there're
> other protocols like UDP: how can I specify active timeout for

There are settings for other protocols in the same place
eg net.netfilter.nf_conntrack_{udp,icmp,generic}_timeout

> it? Another question, if it will affect underlying packet
> converstation (i want it to remain undisturbed)? And last

Removing a conntrack for a connection that is still alive isn't
going to leave it undisturbed.  These timeouts are a tradeoff between
the likelihood of a connection being stale versus it being alive
but inactive.

> question is how do I specify inactive timeout? I'm not sure that
> it's possible but I can write it. And if so, can you please advice

As I mentioned above, these are the inactive timeouts.

> me how I better done it: nf_ct_extend.. for example.
> 
> So many questions in so little message but I really looking forward
> for your support.
> 
> Thank you in advance,
> -- Alexey

