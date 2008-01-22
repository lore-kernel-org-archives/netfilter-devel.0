From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/5] netns netfilter: change xt_table_register() return
 value convention
Date: Tue, 22 Jan 2008 17:49:38 +0100
Message-ID: <47961EA2.2040700@trash.net>
References: <20080121145205.GF27615@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	devel@openvz.org
To: Alexey Dobriyan <adobriyan@sw.ru>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20080121145205.GF27615@localhost.sw.ru>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Alexey Dobriyan wrote:
> Switch from 0/-E to ptr/PTR_ERR convention.

Applied.

