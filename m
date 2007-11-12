From: "bdschuym@pandora.be" <bdschuym@telenet.be>
Subject: Re:  Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in
      2.6.22.6
Date: Mon, 12 Nov 2007 07:30:13 +0000
Message-ID: <W525604345116071194852613@nocme1bl6.telenet-ops.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: "bdschuym@pandora.be" <bdschuym@telenet.be>,
	"ron lai" <ronlai@cs.stanford.edu>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: "Patrick McHardy" <kaber@trash.net>,
	"Bart De Schuymer" <bdschuym@pandora.be>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

>Van: Patrick McHardy [mailto:kaber@trash.net]
>> Hmm, yes, we'd need to or it with BRNF_BRIDGED. I personally prefer
>> something like that, leaving the call to nf_bridge_put when the skbuff
>> is removed. But it's your call :)
>
>
>Both are fine with me. Does this patch look correct to you?

Yes.

cheers,
Bart



