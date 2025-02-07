Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F9F42069;
	Fri,  7 Feb 2025 22:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738965855; cv=none; b=VCdbpIma1C5mRM9upztEO2K8tKtFdg4IScPMee2ftx4NcuToNwrgdLKDKnhbuXNMJTV3qYIKf+rJmX3AvM0jcBj6O6fwcR549QaBbpElvCS5IAMelN7akPAe3LG2pCMwWz/SUkLMxWnRV7MbGoEFj7m3YKKPP7jLFdKhf8KJ8c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738965855; c=relaxed/simple;
	bh=TDZV89AOBX2YFKVlPXOJAgBnc75fsPEzxH92JaUjJ4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NHA6kAMO4E1dkDM/3xsv2tR389RrgA9MXerLARg/ptCdwAFrDdNDgLG73g/kbr6OA0Dz6fGAQjx1n4yWZg2KUCECy4Tu1gsHNb6CRqKxWHxtwUEGB9HNaR2yTWw6HyI0XlcTvppsucoGYTc8PPiRtkmuiyiez8UIE+hKyHJ/xRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EL6efyjK; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EL6efyjK"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ab74fb599c1so44097166b.0;
        Fri, 07 Feb 2025 14:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738965852; x=1739570652; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9p4ESdWoXjaib9fV4OUyBdDHqaUGl8KIiJHqtkdvtBw=;
        b=EL6efyjKJFYIsvq8FsK8UyEWT08FnRSP4gtpWCQW7gPTAqHftbG0ttawefirU0V+xw
         Hinx1J/KR23P+ygWjBZmP6ZrU98GOMQlJA3Lrssi2f1aN1MHWR6gLdNQghos89X84FvJ
         VjIEJ46Pgs0ILI+DH6Hvs9UOkKepooWo+g1/bXpz3t08+9LYBVwRsL23Ng257id31lcK
         ZTVaxsYzcd5syhMuQufEtTLkf7H5u5gpUTM68GNwDEXnW6NTSQoV58Ae8L5rjPT5w+GG
         K8Z68HSTDmQLvXX7WNW6kaCz9VGRwIC6nyPcdO8oCupUtPk/O5VDfzNfGZFLd72S7Hdw
         T8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738965852; x=1739570652;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9p4ESdWoXjaib9fV4OUyBdDHqaUGl8KIiJHqtkdvtBw=;
        b=slUDTYzjiKwyaTg69sNuX8SN/ClpwmOuIfyUzC9KKPxgou/IjgRWpGc3zTfkojsEk1
         cUtgBrwMsVjcJ8rRbNH8P/+mJNNOgmH52x3Y2P6p/GjD6oRDlHULoa8/dqyUeHahWEbx
         SgEsdWeSUqi4YMQniO56KD/Wutf27PMXIU9O7RrT/bBcQ0CGz+eCtX3PnZzf9cnYfg5a
         geFbL1BZRG21WoP1jgo4cCfvhZvglZ0y6HaqL/Pk3s8M9YIjFbh0UXjDQuYA1TmEP4U1
         KNriPP6XyOSKsRlNfc95Db5hWET7XqqfRmaqmt7vn2cMvSkzpZ3HiBIEDhTzEh2SAoit
         mMWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUD6D/XmxnFz73t2cCYJ6FcIed5kltyHTX3wczv2NoXuUpSQCqBUwWNJ0yQ5RCHAZSt9gWwigiD@vger.kernel.org, AJvYcCUZp5xP45iMSKKn4g3HdG6TgGvkJNm6odPzqNjddpRSty8IZblha30c7MqOObUA9CMem8zUiTGFnSYGLPQEBSae@vger.kernel.org, AJvYcCWHpUcc/TkxknYDXeF+B2SuzSuhOOsX3HgNALSNqh/FdUdajffWfmuhXi1N7LzHJDRud0L3ZkYqEHlPiW8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrQKqlbAeqDiM030OK3kd4RxgHW/piGkovzyoepoLO6USMvL+9
	FLhnzMVE9rQEf63GSPXaWCCVhH7n6hnacC7WJasDYWCo1HulvO7l
X-Gm-Gg: ASbGnctEY8bJ3hEc7qcjm1jkv9Mgi2d1JCiu57fGZ6z2tZMnfTHtW4cSma3CeeB5VaS
	oiVAg0CLqb8sAdlcav6AhhW9KkJwjBta0f6juFqwY10nBAAq2+rihQxofyHaZ5paRUXsa5i6Y3+
	GogNjUIwKraC4LCI+xjlD4FoMTcJqLMzNwGt5K2r9ZvXLIGtRo+whwbQ/bT9D6DNw7V/IPQaTG0
	yzDkFmunMuNv8MuDkWLgjC0FSUA3z08PcfCENy/ThhGVDbhdkmZYGBbSD7X78K78PHOzYgTlBkW
	Jzc=
X-Google-Smtp-Source: AGHT+IFsi3+NWjssSKSXZEmvjnEsxFYODgK8SKJ6cgvDO7NhfH/SlmKt0XPdmk4uFCMFK0SjvH4aEg==
X-Received: by 2002:a17:907:7fa8:b0:ab6:3b87:d32a with SMTP id a640c23a62f3a-ab789c2f3d7mr190605566b.11.1738965852001;
        Fri, 07 Feb 2025 14:04:12 -0800 (PST)
Received: from skbuf ([86.127.124.81])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab773337e98sm337699266b.151.2025.02.07.14.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 14:04:11 -0800 (PST)
Date: Sat, 8 Feb 2025 00:04:08 +0200
From: Vladimir Oltean <olteanv@gmail.com>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>, Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v5 net-next 12/14] bridge: No DEV_PATH_BR_VLAN_UNTAG_HW
 for dsa foreign
Message-ID: <20250207220408.zipucrmm2yafj4wu@skbuf>
References: <20250204194921.46692-1-ericwouds@gmail.com>
 <20250204194921.46692-13-ericwouds@gmail.com>
 <20250207150340.sxhsva7qz7bb7qjd@skbuf>
 <78a30eab-cae6-4026-b701-7d7002fe3abb@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78a30eab-cae6-4026-b701-7d7002fe3abb@gmail.com>

On Fri, Feb 07, 2025 at 09:04:28PM +0100, Eric Woudstra wrote:
> Or should mlxsw_sp_switchdev_blocking_event() use
> switchdev_handle_port_obj_add_foreign() to add the vxlan
> foreign port?
> 
> Then all foreign ports are added in a uniform manner and
> SWITCHDEV_F_NO_FOREIGN is respected.
> 
> I do not have the hardware to test any changes in that code.

Personally, in your place I wouldn't have the courage to refactor that
much in a driver as complex as spectrum, but if you CC the right people
from Nvidia who can test, I guess you could give that a try.

Actually, how I came to spectrum was that I was thinking about an
alternative mechanism of detecting "foreign or not", other than emitting
two switchdev notifiers. You emit just the usual, single one, but
whoever handles it for a foreign bridge port will set a new bool
port_obj_info->handled_by_foreign, very similar to the existing
bool port_obj_info->handled. I was looking around to see who else
open-codes the switchdev object handling rather than use the
switchdev_handle_*() helpers, and that's how I came across spectrum.
It would seem, at first glance, easier to set just this in spectrum:

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 6397ff0dc951..6926aaae7278 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -3953,6 +3953,7 @@ mlxsw_sp_switchdev_vxlan_vlans_add(struct net_device *vxlan_dev,
 		return 0;
 
 	port_obj_info->handled = true;
+	port_obj_info->handled_by_foreign = true;
 
 	bridge_device = mlxsw_sp_bridge_device_find(mlxsw_sp->bridge, br_dev);
 	if (!bridge_device)

and this in the object replication helper:

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index c48f66643e99..be82e79b5feb 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -763,6 +763,8 @@ static int __switchdev_handle_port_obj_add(struct net_device *dev,
 	if (!foreign_dev_check_cb(switchdev, dev))
 		return err;
 
+	port_obj_info->handled_by_foreign = true;
+
 	return __switchdev_handle_port_obj_add(br, port_obj_info, check_cb,
 					       foreign_dev_check_cb, add_cb);
 }

Just some care needs to be taken to only consider "handled_by_foreign"
just when "handled" is true.

I haven't yet decided which variant I like better, just thought I'd
mention this as something which requires a single switchdev notification.

Anyway, in the future I'll have to do some more tweaks with these flags
in the context of LAG. These flags (BR_VLFLAG_ADDED_BY_SWITCHDEV, now
also BR_VLFLAG_TAGGING_BY_SWITCHDEV after this patch) can dynamically
change, and the existing code isn't great because it doesn't handle that.

For example:

ip link add br0 type bridge
ip link set swp0 master br0
ip link set bond0 master br0 # bond0 is a foreign interface to swp0 at this time
bridge vlan add dev bond0 vid 100 # this won't get BR_VLFLAG_TAGGING_BY_SWITCHDEV
ip link set swp1 master bond0 # bond0 is no longer a foreign interface to swp0, assuming the same phys_switch_id
# vid 100 should get BR_VLFLAG_TAGGING_BY_SWITCHDEV during br_switchdev_vlan_replay()

Considering that br_switchdev_vlan_replay() will need to re-evaluate the
BR_VLFLAG_TAGGING_BY_SWITCHDEV flag, I guess I do prefer the simpler
variant after all - it is one call less that will have to be made during
replay as well.
