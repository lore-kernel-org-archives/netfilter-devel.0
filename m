From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrackd] allowing DisableExternalCache in alarm mode
Date: Fri, 28 Aug 2015 18:49:12 +0200
Message-ID: <20150828164912.GD3436@salvia>
References: <CAOkSjBh2KtYcSEQ7=h_h+R9CE53pwGtBAiQ_OZF0aTX0fhY0fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47725 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbbH1Qmw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Aug 2015 12:42:52 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBh2KtYcSEQ7=h_h+R9CE53pwGtBAiQ_OZF0aTX0fhY0fw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 27, 2015 at 12:57:42PM +0200, Arturo Borrero Gonzalez wrote:
> Hi,
> 
> The documentation about DisableExternalCache reads:
> 
>  <<<
>  [...]
>  You can also use this option with the NOTRACK and ALARM modes.
>  This increases CPU consumption in the backup firewall but now you do not
>  need to commit the flow-states during the master failures since they are
>  already in the in-kernel Connection Tracking table. Moreover, you save
>  memory in the backup firewall since you do not need to store the
>  foreign flow-states anymore.
>  >>>
> 
> However, the config parser doesn't allows it. Patch seems rather trivial:
> 
> diff --git a/src/read_config_yy.y b/src/read_config_yy.y
> index 73fabbf..d53aa70 100644
> --- a/src/read_config_yy.y
> +++ b/src/read_config_yy.y
> @@ -908,6 +908,7 @@ sync_mode_alarm_line: refreshtime
>                          | purge
>                          | relax_transitions
>                          | delay_destroy_msgs
> +                        | disable_external_cache
>                          ;
> 
>  sync_mode_ftfw_list:
> 
> 
> However, there seems to be some missing bits somewhere, the backup
> node prints this in the logs:
> 
> [...]
> [Thu Aug 27 12:49:46 2015] (pid=15176) [ERROR] inject-add2: No such
> file or directory
> Thu Aug 27 12:49:46 2015 tcp      6 17949 ESTABLISHED
> src=192.162.26.14 dst=192.168.5.134 sport=39089 dport=2015 [ASSURED]
> mark=0
> [Thu Aug 27 12:49:56 2015] (pid=15176) [ERROR] inject-add2: No such
> file or directory
> Thu Aug 27 12:49:56 2015 tcp      6 17949 ESTABLISHED
> src=192.162.26.14 dst=192.168.5.134 sport=39089 dport=2015 [ASSURED]
> mark=0
> [...]
> 
> Note, always the same connection. In my busy test environment, this
> ENOENT happens every few seconds Perhaps a race condition somewhere?
> 
> I would appreciate any hint/advice/pointer.

Are these FTP data flows? I'm asking this because the master
connection (control flow) may be missing in the conntrack table, thus
the ENOENT error.
