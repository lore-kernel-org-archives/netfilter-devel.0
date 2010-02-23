From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_recent: Fix false hit_count match
Date: Tue, 23 Feb 2010 14:59:46 +0100
Message-ID: <4B83DF52.5000806@trash.net>
References: <20100219174904.1F62CF8C3F@sepang.rtg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org
To: Tim Gardner <timg@tpi.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20100219174904.1F62CF8C3F@sepang.rtg.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Tim Gardner wrote:
>>From 146111514a8c126268e848e45b7dd967329b072f Mon Sep 17 00:00:00 2001
> From: Tim Gardner <tim.gardner@canonical.com>
> Date: Thu, 18 Feb 2010 20:33:00 -0700
> Subject: [PATCH] xt_recent: Fix false match.
> 
> A rule with a zero hit_count will always match.
> 

Also applied, thanks Tim.
