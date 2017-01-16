From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: bridge: netfilter: Fix dropping packets that moving
 through bridge interface
Date: Mon, 16 Jan 2017 21:08:54 +0100
Message-ID: <20170116200854.GA25408@salvia>
References: <e7fd1864-91dc-ca2d-8ce5-4cb7b589f1f5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Artur Molchanov <arturmolchanov@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e7fd1864-91dc-ca2d-8ce5-4cb7b589f1f5@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Cc'ing Greg.

On Mon, Jan 16, 2017 at 09:44:10PM +0300, Artur Molchanov wrote:
> commit 14221cc45caad2fcab3a8543234bb7eda9b540d5 upstream.
> 
> Please apply this commit to fix bug that makes impossible to use local
> Docker containers with bridge network.
> 
> Cc: <stable@vger.kernel.org> # 4.9.x

Greg, please, cherry-pick this commit to -stable 4.9.x.

Thanks a lot!
