From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 7/8 v2] textsearch: convert kmalloc + memset to kzalloc
Date: Wed, 25 Jun 2008 13:04:13 +0200
Message-ID: <4862262D.6080804@trash.net>
References: <> <1214389507-21425-1-git-send-email-joonwpark81@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev <netdev@vger.kernel.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Joonwoo Park <joonwpark81@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1214389507-21425-1-git-send-email-joonwpark81@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Joonwoo Park wrote:
> convert kmalloc + memset to kzalloc for alloc_ts_config

Applied, thanks.
