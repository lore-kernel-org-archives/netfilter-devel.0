From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: event-driven connection tracking
Date: Thu, 14 Oct 2010 14:01:31 +0200
Message-ID: <4CB6F11B.6000103@netfilter.org>
References: <4CB5CF17.3090302@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4CB5CF17.3090302@googlemail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 13/10/10 17:24, Mr Dash Four wrote:
> Is it possible to use event-driven connection tracking - with
> conntrack-utils or by other means?
> 
> Ideally, what I would like to do is 'register' a handler for particular
> connection events (when new connection is established and then closed
> for example) based on particular pre-defined filter (say, by protocol,
> source/destination ip etc) and execute a program code/function (if done
> programmatically) or a script (if done outside the connection-tracking
> domain) to do what I want?
> Currently, the only way to track such 'events' is if I include a
> separate chain in iptables tracking a particular connection (and logging
> the event via a normal log jump), but that is not enough for me as I
> also need to trigger a full dump based on that particular 'filter' and
> end this dump when the connection is closed. Any ideas?

You can use libnetfilter_conntrack for that:
http://www.netfilter.org/projects/libnetfilter_conntrack/index.html

There are several examples under utils/ in the tarballs that are
distributed.
